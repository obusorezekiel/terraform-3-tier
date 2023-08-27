output "alb-dns" {
  value = aws_lb.web-tier-lb.dns_name
}