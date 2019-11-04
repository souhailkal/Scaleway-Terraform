resource "scaleway_security_group" "cluster_default" {
  name        = "cluster_default"
  description = "allow all traffic"
}

resource "scaleway_security_group_rule" "cluster_default" {
  security_group = "${scaleway_security_group.cluster_default.id}"
  action         = "accept"
  direction      = "inbound"
  ip_range       = "0.0.0.0/0"
  protocol       = "TCP"
}
