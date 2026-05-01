/**
 * API client for Kakebo backend
 * Centralized fetching with error handling, types, and validation
 */

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

if (!API_BASE_URL) {
	console.warn(
		'VITE_API_BASE_URL is not defined. Please set it in your .env.local file.',
	);
}

// ============================================================================
// Type Definitions
// ============================================================================

export interface Expense {
	id?: number | null;
	expenseName: string;
	amount: number;
	expenseDate: string; // ISO 8601 format
}

export interface Income {
	id?: number | null;
	incomeName: string;
	amount: number;
	incomeDate: string; // ISO 8601 format
}

export interface ApiResponse<T> {
	data: T;
	success: boolean;
	message?: string;
}

export interface ApiListResponse<T> {
	data: T[];
}

export class ApiError extends Error {
	constructor(
		public status: number,
		message: string,
		public details?: unknown,
	) {
		super(message);
		this.name = 'ApiError';
	}
}

// ============================================================================
// Validation Helpers (lightweight, no dependencies)
// ============================================================================

function validateExpense(expense: Partial<Expense>): Expense {
	if (!expense.expenseName || expense.expenseName.trim() === '') {
		throw new Error('expenseName is required');
	}
	if (expense.amount === undefined || expense.amount === null) {
		throw new Error('amount is required');
	}
	if (typeof expense.amount !== 'number' || expense.amount <= 0) {
		throw new Error('amount must be a positive number');
	}
	if (!expense.expenseDate || expense.expenseDate.trim() === '') {
		throw new Error('expenseDate is required');
	}
	return {
		expenseName: expense.expenseName.trim(),
		amount: expense.amount,
		expenseDate: expense.expenseDate,
	};
}

function validateIncome(income: Partial<Income>): Income {
	if (!income.incomeName || income.incomeName.trim() === '') {
		throw new Error('incomeName is required');
	}
	if (income.amount === undefined || income.amount === null) {
		throw new Error('amount is required');
	}
	if (typeof income.amount !== 'number' || income.amount <= 0) {
		throw new Error('amount must be a positive number');
	}
	if (!income.incomeDate || income.incomeDate.trim() === '') {
		throw new Error('incomeDate is required');
	}
	return {
		incomeName: income.incomeName.trim(),
		amount: income.amount,
		incomeDate: income.incomeDate,
	};
}

// ============================================================================
// HTTP Client
// ============================================================================

interface FetchOptions extends RequestInit {
	timeout?: number;
}

async function fetchApi<T>(
	endpoint: string,
	options: FetchOptions = {},
): Promise<T> {
	const url = `${API_BASE_URL}${endpoint}`;
	const timeout = options.timeout || 30000;
	const controller = new AbortController();
	const timeoutId = setTimeout(() => controller.abort(), timeout);

	try {
		const response = await fetch(url, {
			...options,
			signal: controller.signal,
			headers: {
				'Content-Type': 'application/json',
				...options.headers,
			},
		});

		if (!response.ok) {
			const errorBody = await response.text();
			throw new ApiError(
				response.status,
				`HTTP ${response.status}: ${response.statusText}`,
				errorBody,
			);
		}

		// Handle empty responses (204 No Content)
		if (response.status === 204) {
			return undefined as T;
		}

		return response.json() as Promise<T>;
	} catch (error) {
		if (error instanceof ApiError) {
			throw error;
		}
		if (error instanceof TypeError) {
			throw new ApiError(0, 'Network error. Please check your connection.', error);
		}
		throw new ApiError(500, 'Unknown error occurred', error);
	} finally {
		clearTimeout(timeoutId);
	}
}

// ============================================================================
// Expenses API
// ============================================================================

export async function getExpenses(): Promise<Expense[]> {
	try {
		const response = await fetchApi<Expense[]>('/expenses');
		return Array.isArray(response) ? response : [];
	} catch (error) {
		console.error('Error fetching expenses:', error);
		throw error;
	}
}

export async function getExpense(id: number): Promise<Expense> {
	try {
		return await fetchApi<Expense>(`/expenses/${id}`);
	} catch (error) {
		console.error(`Error fetching expense ${id}:`, error);
		throw error;
	}
}

export async function createExpense(expense: Partial<Expense>): Promise<Expense> {
	const validated = validateExpense(expense);
	try {
		return await fetchApi<Expense>('/expenses', {
			method: 'POST',
			body: JSON.stringify(validated),
		});
	} catch (error) {
		console.error('Error creating expense:', error);
		throw error;
	}
}

export async function updateExpense(
	id: number,
	expense: Partial<Expense>,
): Promise<Expense> {
	// Partial update: only include non-null fields
	const payload = Object.fromEntries(
		Object.entries(expense).filter(([, v]) => v !== null && v !== undefined),
	);

	try {
		return await fetchApi<Expense>(`/expenses/${id}`, {
			method: 'PUT',
			body: JSON.stringify(payload),
		});
	} catch (error) {
		console.error(`Error updating expense ${id}:`, error);
		throw error;
	}
}

export async function deleteExpense(id: number): Promise<void> {
	try {
		await fetchApi<void>(`/expenses/${id}`, {
			method: 'DELETE',
		});
	} catch (error) {
		console.error(`Error deleting expense ${id}:`, error);
		throw error;
	}
}

// ============================================================================
// Incomes API
// ============================================================================

export async function getIncomes(): Promise<Income[]> {
	try {
		const response = await fetchApi<Income[]>('/incomes');
		return Array.isArray(response) ? response : [];
	} catch (error) {
		console.error('Error fetching incomes:', error);
		throw error;
	}
}

export async function getIncome(id: number): Promise<Income> {
	try {
		return await fetchApi<Income>(`/incomes/${id}`);
	} catch (error) {
		console.error(`Error fetching income ${id}:`, error);
		throw error;
	}
}

export async function createIncome(income: Partial<Income>): Promise<Income> {
	const validated = validateIncome(income);
	try {
		return await fetchApi<Income>('/incomes', {
			method: 'POST',
			body: JSON.stringify(validated),
		});
	} catch (error) {
		console.error('Error creating income:', error);
		throw error;
	}
}

export async function updateIncome(
	id: number,
	income: Partial<Income>,
): Promise<Income> {
	// Partial update: only include non-null fields
	const payload = Object.fromEntries(
		Object.entries(income).filter(([, v]) => v !== null && v !== undefined),
	);

	try {
		return await fetchApi<Income>(`/incomes/${id}`, {
			method: 'PUT',
			body: JSON.stringify(payload),
		});
	} catch (error) {
		console.error(`Error updating income ${id}:`, error);
		throw error;
	}
}

export async function deleteIncome(id: number): Promise<void> {
	try {
		await fetchApi<void>(`/incomes/${id}`, {
			method: 'DELETE',
		});
	} catch (error) {
		console.error(`Error deleting income ${id}:`, error);
		throw error;
	}
}

// ============================================================================
// Utility Functions
// ============================================================================

/**
 * Format a number as currency (EUR by default)
 */
export function formatCurrency(
	value: number,
	locale: string = 'es-ES',
	currency: string = 'EUR',
): string {
	return new Intl.NumberFormat(locale, {
		style: 'currency',
		currency,
		minimumFractionDigits: 2,
		maximumFractionDigits: 2,
	}).format(value);
}

/**
 * Format a date string to locale format
 */
export function formatDate(
	dateString: string,
	locale: string = 'es-ES',
	options?: Intl.DateTimeFormatOptions,
): string {
	const date = new Date(dateString);
	return date.toLocaleDateString(locale, options || {});
}

/**
 * Parse ISO date string to Date object
 */
export function parseDate(dateString: string): Date {
	return new Date(dateString);
}

/**
 * Format date for HTML input[type="datetime-local"]
 */
export function formatDateForInput(date: Date | string): string {
	if (typeof date === 'string') {
		date = new Date(date);
	}
	return date.toISOString().slice(0, 16);
}
