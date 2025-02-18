const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

// Example fetching
export async function fetchPosts() {
	const response = await fetch('https://jsonplaceholder.typicode.com/posts');
	if (!response.ok) {
		throw new Error('Error fetching posts');
	}
	return response.json();
}

// Fecht incomes
export async function fetchIncomes() {
	const response = await fetch(API_BASE_URL + '/incomes'); // Cambia esta URL por la de tu API.

	if (!response.ok) {
		throw new Error('Error al obtener datos de la API');
	}

	const data = await response.json();

	return {
		data
	};
}

// Fecht expenses
export async function fetchExpenses() {
	const response = await fetch(API_BASE_URL + '/expenses'); // Cambia esta URL por la de tu API.

	if (!response.ok) {
		throw new Error('Error al obtener datos de la API');
	}

	const data = await response.json();

	return {
		data
	};
}
