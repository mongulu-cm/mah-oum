# =============
# --- Roles ---
# -------------

# Appsync role

data "aws_iam_policy_document" "iam_appsync_role_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["appsync.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_appsync_role" {
  name               = "${var.prefix}_iam_appsync_role"
  assume_role_policy = data.aws_iam_policy_document.iam_appsync_role_document.json
}

# ================
# --- Policies ---
# ----------------

data "aws_caller_identity" "current" {}

# DynamoDB policy
data "aws_iam_policy_document" "iam_dynamodb_policy_document" {
  statement {
    actions   = ["dynamodb:DeleteItem","dynamodb:GetItem","dynamodb:PutItem",
                 "dynamodb:Query","dynamodb:Scan","dynamodb:UpdateItem"
                ]
    resources = ["arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/mah-oum_Events",
                 "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/mah-oum_Comments",
                 "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/mah-oum_Comments/index/LSI-Comments-by-eventId-createdAt"
                ]
  }
}

resource "aws_iam_policy" "iam_dynamodb_policy" {
  name   = "${var.prefix}_iam_dynamodb_policy"
  policy = data.aws_iam_policy_document.iam_dynamodb_policy_document.json
}


# ===================
# --- Attachments ---
# -------------------

# Attach Invoke Lambda policy to AppSync role.

resource "aws_iam_role_policy_attachment" "appsync_dynamodb" {
  role       = aws_iam_role.iam_appsync_role.name
  policy_arn = aws_iam_policy.iam_dynamodb_policy.arn
}
