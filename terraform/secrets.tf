resource "random_password" "secret_key" {
  length = 20
}

resource "kubernetes_secret" "secret_key" {
  metadata {
    name      = "my-secret-key"
    namespace = kubernetes_namespace.sherpany.metadata.0.name
  }

  data = {
    secret_key = random_password.secret_key.result
  }
}

resource "random_password" "postgres_pass" {
  length = 20
}

resource "kubernetes_secret" "postgres_pass" {
  metadata {
    name      = "my-postgres-pass"
    namespace = kubernetes_namespace.sherpany.metadata.0.name
  }

  data = {
    postgres_password = random_password.postgres_pass.result
  }
}
