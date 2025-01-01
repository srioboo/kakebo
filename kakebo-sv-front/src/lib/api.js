// Example fetching
export async function fetchPosts() {
  const response = await fetch('https://jsonplaceholder.typicode.com/posts');
  if (!response.ok) {
    throw new Error('Error fetching posts');
  }
  return response.json();
}

// Fecht expenses
export async function fetchExpenses () {
	const response = await fetch('http://localhost:9090/expenses/1'); // Cambia esta URL por la de tu API.

	if (!response.ok) {
		throw new Error('Error al obtener datos de la API');
	}

	const data = await response.json();

	console.log(data);
	return {
		data
	};
};