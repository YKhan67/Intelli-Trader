import os
import logging
from sqlalchemy import select, and_, update
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import ModelVersionDB
from backend.modules.models import ModelStatus

logger = logging.getLogger("ModelVersioner")

class ModelVersioner:
    @staticmethod
    async def get_latest_live_model(module_name: str):
        """
        Returns the path/version of the latest model marked as LIVE for a specific module.
        """
        async with AsyncSessionLocal() as session:
            stmt = select(ModelVersionDB).where(
                and_(
                    ModelVersionDB.module == module_name,
                    ModelVersionDB.status == ModelStatus.LIVE
                )
            ).order_by(ModelVersionDB.created_at.desc()).limit(1)
            
            res = await session.execute(stmt)
            version = res.scalar_one_or_none()
            return version

    @staticmethod
    async def promote_to_live(version_str: str):
        """
        Marks a specific version as LIVE and demotes previous LIVE models.
        """
        async with AsyncSessionLocal() as session:
            stmt = select(ModelVersionDB).where(ModelVersionDB.version == version_str)
            res = await session.execute(stmt)
            version = res.scalar_one_or_none()
            
            if not version:
                logger.error(f"Version {version_str} not found.")
                return False

            # Demote others
            await session.execute(
                update(ModelVersionDB)
                .where(and_(ModelVersionDB.module == version.module, ModelVersionDB.status == ModelStatus.LIVE))
                .values(status=ModelStatus.PAPER)
            )

            version.status = ModelStatus.LIVE
            await session.commit()
            logger.info(f"Model {version_str} promoted to LIVE.")
            return True
