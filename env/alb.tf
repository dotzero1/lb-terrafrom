## ALB SECURITY GROUPS ##
resource "aws_security_group" "sg_alb" {
  count = var.load_balancer_count

  name   = "${var.environment}-alb-sg-${count.index}"
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sg_alb_rule_001" {
  count = var.load_balancer_count

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  security_group_id = aws_security_group.sg_alb[count.index].id
  cidr_blocks       = ["0.0.0.0/0"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sg_alb_rule_002" {
  count = var.load_balancer_count

  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_alb[count.index].id
  cidr_blocks       = ["0.0.0.0/0"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sg_alb_rule_003" {
  count = var.load_balancer_count

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_alb[count.index].id
  cidr_blocks       = ["0.0.0.0/0"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb" "alb" {
  count = var.load_balancer_count

  name            = "${var.environment}-alb-${count.index}"
  internal        = false
  security_groups = [aws_security_group.sg_alb[count.index].id]
  subnets         = var.public_subnet_ids
  idle_timeout    = 60
}


resource "aws_alb_listener" "service_https" {
  count = var.load_balancer_count

  load_balancer_arn = aws_alb.alb[count.index].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.domain_certificate_arn

  // this means that none of the other listener rules are caught, in this case we 404
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

resource "aws_alb_listener" "service_http" {
  count = var.load_balancer_count

  load_balancer_arn = aws_alb.alb[count.index].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

## OUTPUTS ##
output "alb_arns" {
  description = "Map of ALB ARNs with predictable keys"
  value = {
    for idx, alb in aws_alb.alb :
    idx => alb.arn
  }
}

output "alb_dns_names" {
  description = "Map of ALB DNS names with predictable keys"
  value = {
    for idx, alb in aws_alb.alb :
    idx => alb.dns_name
  }
}

output "alb_zone_ids" {
  description = "Map of ALB zone IDs with predictable keys"
  value = {
    for idx, alb in aws_alb.alb :
    idx => alb.zone_id
  }
}
