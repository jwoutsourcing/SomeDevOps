FROM hashicorp/terraform:light
WORKDIR /app
COPY vpc.tf /app
COPY /home/ec2-user/.aws/credentials /app/.aws/credentials
RUN ["terraform", "init"]
CMD ["plan"]
