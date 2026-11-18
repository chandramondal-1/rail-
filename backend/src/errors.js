export class ApiError extends Error {
  constructor(status, code, message) {
    super(message);
    this.status = status;
    this.code = code;
  }
}

export const badRequest = (message) =>
  new ApiError(400, 'bad_request', message);

export const notFound = (message) => new ApiError(404, 'not_found', message);

export const upstreamError = (message) =>
  new ApiError(502, 'upstream_error', message);
