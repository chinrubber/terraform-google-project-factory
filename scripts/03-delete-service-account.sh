set -e

PROJECT_ID=$1
SA_ID=$2

SA_LIST=$(gcloud --project="$PROJECT_ID" iam service-accounts list || exit 1)

if [[ $SA_LIST = *"$SA_ID"* ]]; then
    echo "Deleting service account $SA_ID in project $PROJECT_ID"
    gcloud iam service-accounts delete --quiet --project="$PROJECT_ID" "$SA_ID"
else
    echo "Service account not listed. It appears to have already been deleted."
fi
