resource "random_password" "secret_key" {
  length = 20
}

resource "kubernetes_secret" "secret_key" {
  metadata {
    name      = "${var.system}-secrets"
    namespace = kubernetes_namespace.sherpany.metadata.0.name
  }

  data = {
    secret-key        = random_password.secret_key.result
    postgres-password = random_password.postgres_pass.result
  }
}

resource "random_password" "postgres_pass" {
  length = 20
}
