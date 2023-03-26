resource "aws_iot_thing" "raspberry_pi_thing" {
  name = "RaspberryPiThing"
}

resource "aws_iot_certificate" "raspberry_pi_certificate" {
  csr          = file("path/########") #cert‚ÌPath‚ð“ü‚ê‚é
  status       = "ACTIVE"
}

resource "aws_iot_policy" "raspberry_pi_policy" {
  name = "RaspberryPiPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "iot:*"
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iot_policy_attachment" "raspberry_pi_attachment" {
  policy = aws_iot_policy.raspberry_pi_policy.name
  target = aws_iot_certificate.raspberry_pi_certificate.arn
}
