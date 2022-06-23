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