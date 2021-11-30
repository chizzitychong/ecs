resource "aws_cloudwatch_log_group" "trade_exec" {
  name              = "trade_exec"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "trade_exec" {
  family = "trade_exec"

  container_definitions = <<EOF
[
  {
    "name": "trade_exec",
    "image": "trade_exec",
    "cpu": 0,
    "memory": 128,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "us-west-1",
        "awslogs-group": "trade_exec",
        "awslogs-stream-prefix": "complete-ecs"
      }
    }
  }
]
EOF
}

resource "aws_ecs_service" "trade_exec" {
  name            = "trade_exec"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.trade_exec.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}
