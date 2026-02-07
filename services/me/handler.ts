import type { APIGatewayProxyHandlerV2WithJWTAuthorizer } from "aws-lambda";

export const handler: APIGatewayProxyHandlerV2WithJWTAuthorizer = async (event) => {
  const claims = event.requestContext.authorizer?.jwt.claims;
  if (!claims?.sub) {
    return { statusCode: 401, body: "Unauthorized" };
  }

  return {
    statusCode: 200,
    body: JSON.stringify({
      user_id: claims.sub,
      email: claims.email,
    }),
  };
};
