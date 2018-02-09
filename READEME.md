# Packer Example

## Installation

```shell
$ brew install packer
```

## Run

Create a json file (e.g., `variables.json`) containing

```
{
  "aws_access_key": "your aws access key",
  "aws_secret_key": "your aws secret key"
}
```

Then run

```shell
$ packer build -var-file=variables.json main.json
```
