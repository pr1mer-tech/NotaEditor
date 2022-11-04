import { authorize } from "./authorize";

export const handle = async (request: Request): Promise<Response> => {
    const url = new URL(request.url);
    const path = url.pathname;

    // Get the authorization header
    const authHeader = request.headers.get('Authorization');

    // If the authorization header is not set, return a 401
    if (!authHeader) {
        return new Response('Unauthorized', {
            status: 401,
            headers: {
                'WWW-Authenticate': 'Basic realm="Access to the staging site", charset="UTF-8"'
            }
        });
    }

    // If the authorization header is set, check if the user is authorized
    const auth = await authorize(authHeader);

    // If the user is not authorized, return a 403
    if (!auth) {
        return new Response('Forbidden', {
            status: 403
        });
    }

    const options: RequestInit = {
        method: request.method.toUpperCase(),
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${OPENAI_TOKEN}`
        }
    }
    try {
        if (request.method === 'POST') {
            options.body = await request.text();
        }
    } catch (e) {
        console.error(e);
    }
    
    const response = await fetch(`https://api.openai.com/v1${path}`, options);

    // Forwards response to client
    return response;
}