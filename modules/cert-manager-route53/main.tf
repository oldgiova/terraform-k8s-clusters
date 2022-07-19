resource "aws_iam_user" "issuer" {
  name = var.aws_route53_user_name
}

resource "aws_iam_policy" "policy" {
  name        = "route53-certmanager-policy"
  description = "Route53 CertManager Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "arn:aws:route53:::hostedzone/*"
    },
    {
      "Effect": "Allow",
      "Action": "route53:ListHostedZonesByName",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "issuer_attachment" {
  user       = aws_iam_user.issuer.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_access_key" "issuer" {
  user = aws_iam_user.issuer.name
}

resource "kubernetes_secret" "aws_keys" {
  metadata {
    name      = "route53-credentials-secret"
    namespace = "cert-manager"
  }
  data = {
    access-key-id     = aws_iam_access_key.issuer.id
    secret-access-key = aws_iam_access_key.issuer.secret
  }
}


resource "kubernetes_manifest" "issuer_letsencrypt_prod" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = var.issuer_name
    }
    "spec" = {
      "acme" = {
        "email"  = var.issuer_email
        "server" = "https://acme-staging-v02.api.letsencrypt.org/directory"
        "privateKeySecretRef" = {
          "name" = var.issued_secret_name
        }
        "solvers" = [
          {
            "dns01" = {
              "route53" = {
                "accessKeyID" = aws_iam_access_key.issuer.id
                "secretAccessKeySecretRef" = {
                  "name" = "route53-credentials-secret"
                  "key"  = "secret-access-key"
                }
                "hostedZoneID" = var.aws_hosted_zone_id
                "region"       = var.aws_region
              }
            }
          }
        ]
      }
    }
  }
}

