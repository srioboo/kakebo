export const load = async ({ fetch }) => {
	const response = await fetch('https://localhost:909/expenses/1');

	if (!response.ok) {
		throw new Error('Error getting data from API');
	}

	const expenses = await response.json();
	return {
		expenses
	};
};
