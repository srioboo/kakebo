import { fetchPosts, fetchExpenses } from '$lib/api';

export async function load() {
  try {
    // const posts = await fetchPosts();
		const expenses = await fetchExpenses();
    // return { posts, expenses };
		return {expenses};
  } catch (error) {
    return { error: error.message };
  }

}
