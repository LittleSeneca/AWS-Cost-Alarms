resource "null_resource" "zip_lambda" {
  provisioner "local-exec" {
    command = "zip -j lambda_function_payload.zip lambda_function.py"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
