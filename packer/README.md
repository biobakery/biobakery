## bioBakery Packer gCloud/local (Build VM images)
Packer builds automated machine images and creates identical machine images for multiple platforms from a single source configuration. Packer allows us to deploy the custom biobakery images into google cloud VM instances, therefore can be used by workshops connected through [guacamole servers](https://huttenhower.sph.harvard.edu/guacamole).

### Requirements 
- [Packer](https://www.packer.io/downloads)
- [gCloud SDK](https://cloud.google.com/sdk/docs/install)
- Google Cloud Service Account Key Credentials (Please ping Sagun/Lauren on slack)
- [Docker (Optional for local build)](https://docs.docker.com/get-docker/)


### Getting Started
```
$ git clone https://github.com/biobakery/packer-biobakery
$ cd packer-biobakery
$ packer init
```
#### Google Cloud Image Build
```
packer build gcloud-packer.json
```
The google cloud image will be ready in the `service account` associated google cloud console after the build is completed.

#### Local Docker Container Image Build
```
packer build local-packer.pkr.hcl
```
The docker VM instances will start running in the `local machine` after the build is completed.