# To create immutable flow the below steps

- **Install packer on machine**
   > https://www.packer.io/downloads

- **Setup the aws cli key in cds-webstore-ami.json**
    ```
        "aws_access_key": "YOUR_ACCESS_KEY",
        "aws_secret_key": "YOUR_SECRET_KEY"
    ```

- **Run build command to create ami**
    ```
    packer build cds-webstore-ami.json 
    ```
- Find the ami in us-east-1 region

