# --- AppSync Setup ---

# Create the AppSync GraphQL api.
resource "aws_appsync_graphql_api" "appsync" {
  name                = "${var.prefix}_appsync"
  schema              = file("schema.graphql")
  authentication_type = "API_KEY"
}

# Create the API key.
resource "aws_appsync_api_key" "appsync_api_key" {
  api_id = aws_appsync_graphql_api.appsync.id
}

# --- DynamoDB ---

resource "aws_dynamodb_table" "Comments" {

  name = "${var.prefix}_Comments"
  attribute {
    name = "createdAt"
    type = "S"
  }

  attribute {
    name = "eventId"
    type = "S"
  }

  attribute {
    name = "commentId"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  hash_key     = "eventId"
  range_key     = "commentId"
  read_capacity = "1"
  write_capacity = "1"

  local_secondary_index {
    name            = "LSI-Comments-by-eventId-createdAt"
    projection_type = "ALL"
    range_key       = "createdAt"
  }
}

resource "aws_dynamodb_table" "Events" {
  name         = "${var.prefix}_Events"
  attribute {
    name = "id"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  hash_key     = "id"
  read_capacity = "1"
  write_capacity = "1"
}

resource "aws_appsync_datasource" "Comments" {
  name             = "Comments"
  api_id           = aws_appsync_graphql_api.appsync.id
  service_role_arn = aws_iam_role.iam_appsync_role.arn
  type             = "AMAZON_DYNAMODB"
  dynamodb_config {
    table_name = aws_dynamodb_table.Comments.name
  }
}

resource "aws_appsync_datasource" "Events" {
  name             = "Events"
  api_id           = aws_appsync_graphql_api.appsync.id
  service_role_arn = aws_iam_role.iam_appsync_role.arn
  type             = "AMAZON_DYNAMODB"
  dynamodb_config {
    table_name = aws_dynamodb_table.Events.name
  }
}


# --- Resolvers ---

resource "aws_appsync_resolver" "EventComments" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Event"
  field       = "comments"
  data_source = aws_appsync_datasource.Comments.name

  request_template  = file("./resolvers/Event.comments/request.vtl")
  response_template = file("./resolvers/Event.comments/response.vtl")
}

resource "aws_appsync_resolver" "createEvent" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Mutation"
  field       = "createEvent"
  data_source = aws_appsync_datasource.Events.name

  request_template  = file("./resolvers/createEvent/request.vtl")
  response_template = file("./resolvers/createEvent/response.vtl")
}

resource "aws_appsync_resolver" "deleteEvent" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Mutation"
  field       = "deleteEvent"
  data_source = aws_appsync_datasource.Events.name

  request_template  = file("./resolvers/deleteEvent/request.vtl")
  response_template = file("./resolvers/deleteEvent/response.vtl")
}

resource "aws_appsync_resolver" "commentOnEvent" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Mutation"
  field       = "commentOnEvent"
  data_source = aws_appsync_datasource.Comments.name

  request_template  = file("./resolvers/commentOnEvent/request.vtl")
  response_template = file("./resolvers/commentOnEvent/response.vtl")
}

resource "aws_appsync_resolver" "getEvent" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Query"
  field       = "getEvent"
  data_source = aws_appsync_datasource.Events.name

  request_template  = file("./resolvers/getEvent/request.vtl")
  response_template = file("./resolvers/getEvent/response.vtl")
}

resource "aws_appsync_resolver" "listEvents" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Query"
  field       = "listEvents"
  data_source = aws_appsync_datasource.Events.name

  request_template  = file("./resolvers/listEvents/request.vtl")
  response_template = file("./resolvers/listEvents/response.vtl")
}


