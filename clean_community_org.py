# Script to delete empty models from the community org.
# Can be run manually or scheduled to run periodically in the Space.
# Usage: python clean_community_org.py
#
# 1. List models from https://huggingface.co/mergekit-community
# 2. Filter out models with no files.
# 3. Filter out models that are newer than 1 hour.
# 4. Delete the remaining models.
from datetime import datetime, timezone

from huggingface_hub import HfApi


def garbage_collect_empty_models(token: str | None = None):
    api = HfApi(token=token)
    now = datetime.now(timezone.utc)
    print("Running garbage collection on mergekit-community.")
    for model in api.list_models(author="mergekit-community", full=True):
        if model.siblings and len(model.siblings) > 1:
            # If model has files, then it's not empty
            continue
        if (now - model.last_modified).total_seconds() < 3600:
            # If model was updated in the last hour, then keep it
            # to avoid deleting models that are being uploaded
            print("Skipping", model.modelId, "(recently updated)")
            continue
        try:
            print(f"Deleting {model.modelId}")
            api.delete_repo(model.modelId, missing_ok=True)
        except Exception as e:
            print(f"Error deleting {model.modelId}: {e}")


if __name__ == "__main__":
    garbage_collect_empty_models()
