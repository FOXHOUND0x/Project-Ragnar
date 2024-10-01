resource "aws_iam_role" "ragnar_lamda_role" {
    name = "ragnar_lamda_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Sid = "AllowLambdaServiceToAssumeRole",
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_policy" "policy_bucket_attachment" {
    name = "ragnar_bucket_attachment"
    path = "/"
    description = "bucket permission"

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Action = [
                    "s3:GetObject",
                    "s3:PutObject",
                    "s3:ListBucket"
                ],
                Resource = "arn:aws:s3:::ragnar_db_bucket/*"
            }
        ]
    })
}

resource "aws_iam_policy_attachment" "ragnar_role_attach" {
    name = "ragnar_role_attach"
    roles = [aws_iam_role.ragnar_lamda_role.name]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}