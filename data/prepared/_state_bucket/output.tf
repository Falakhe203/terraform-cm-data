output "bucket_id" {
    description = "State bucket ID"
    value = module.s3-bucket-state.s3_bucket_id
}
