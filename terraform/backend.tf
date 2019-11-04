terraform {
  backend "s3" {
    bucket                      = "bucket-terraform-state"
    key                         = "poc-application-division.tfstate"
    region                      = "nl-ams"
    endpoint                    = "https://s3.nl-ams.scw.cloud"
    access_key                  = "*****"
    secret_key                  = "*****"
    skip_credentials_validation = true
    skip_region_validation      = true
  }
}
