resource "aws_iam_user" "oversecured_user" {
  name          = "${var.project_prefix}-user"
  force_destroy = true
}

resource "aws_iam_user_policy" "oversecured_user_policy" {
  name   = "${var.project_prefix}-user-policy"
  user   = aws_iam_user.oversecured_user.name
  policy = templatefile("${path.module}/tf_templates/policy-template.tpl", { sg_arn = aws_security_group.lb_sg.arn })
}

resource "aws_iam_user_login_profile" "oversecured_user_login_profile" {
  user            = aws_iam_user.oversecured_user.name
  password_length = 12
}
