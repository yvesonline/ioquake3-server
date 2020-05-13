# Dedicated [ioquake3](https://ioquake3.org/) server

## Synopsis

Run a dedicated [ioquake3](https://ioquake3.org/) server on GCP.

## Requirements

- Build, tag and upload the **Docker image** to your Google Container registry:
```
docker-compose build --no-cache ioquake3
docker tag ioquake3server_ioquake3 gcr.io/<your GCP project>/ioquake3-ded:<tag>
docker push gcr.io/<your GCP project>/ioquake3-ded:<tag>
```
(_Note_: Don't forget to update the tag if you're uploading a new version.)

(_Note 2_: Don't forget to copy the `baseq3` folder from your original CD-ROM to the `ioquake3` folder.)

(_Note 3_: Modify `server.cfg` in the `ioquake3` folder to give your server a name and password.)

- A Google **service account** and its credentials placed in a file called `ioquake3.json` in the root folder.

(_Note_: Add the following permissions: `Compute Admin`, `Service Account User`, `Storage Object Viewer`.)

## Usage with Terraform (Recommended)

- Adapt `variables.auto.tfvars` to your needs, don't forget to change `docker_declaration`
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

## Usage with `gcloud` command

- Reserve IP address
```
gcloud compute addresses create ioquake3-ip \
    --region <your desired GCP region> --project <your GCP project>
```

- Show IP address
```
gcloud compute addresses describe ioquake3-ip \
    --region <your desired GCP region> --project <your GCP project>
```

- Create VM
```
gcloud compute instances create-with-container ioquake3 \
    --container-image gcr.io/<your GCP project>/ioquake3-ded:<tag> \
    --machine-type f1-micro \
    --project <your GCP project> \
    --zone <your desired GCP zone> \
    --tags ioquake3-server \
    --address <ip address>
```
(Note: Replace IP address with actual reserved IP address.)

- Create Firewall rule
```
gcloud compute firewall-rules create allow-ioquake3 \
    --allow tcp:27950,tcp:27952,tcp:27960,tcp:27965,udp:27950,udp:27952,udp:27960,udp:27965 \
    --target-tags ioquake3-server --project <your GCP project>
```

- Delete IP address
```
gcloud compute addresses delete ioquake3-ip --project <your GCP project> --region <your GCP region>
```

- Delete VM
```
gcloud compute instances delete ioquake3 --project <your GCP project> --zone <your GCP zone>
```