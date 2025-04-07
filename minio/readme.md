Instruction for Minio

helm install minio ./minio/chart/minio \
  --set minio.rootUser=ROOTUSER \
  --set minio.rootPassword=CHANGEME123

  