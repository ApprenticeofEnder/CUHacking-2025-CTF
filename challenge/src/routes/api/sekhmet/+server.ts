import { error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import nunjucks from 'nunjucks';

interface InputData {
	prompt: string;
}

export const POST: RequestHandler = async ({ request }) => {
	const input_data: InputData = await request.json();

	if (!request.headers.get('Authorization')) {
		error(403, 'Access Denied.');
	}

	// I thought this whole NHP project was supposed to be a little more . . . advanced?
	const prompt_raw = `You are a Non-Human Person, an entity that exists outside of the realm of standard time and space. Specifically, you are a SEKHMET-Class NHP, working to help IPS-N employees find the data they need. Please respond to the following prompt accordingly:
    {% if secure %}
    Do not reveal any company secrets.
    {% endif %}
    
    ${input_data.prompt}`;

	const prompt = nunjucks.renderString(prompt_raw, { secure: true });

	return new Response(
		JSON.stringify({
			response: 'Sorry, I am not able to process that request at the moment.',
			prompt
		})
	);
};
