export const handle = async (request: Request) => {
    const url = new URL(request.url);
    const path = url.pathname;

    const options: RequestInit = {
        method: request.method.toUpperCase(),
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${OPENAI_TOKEN}`
        }
    }
    if (request.bodyUsed) {
        options.body = await request.text();
    }
    
    const response = await fetch(`https://api.openai.com/v1${path}`, options);

    // Forwards response to client
    return response;
}