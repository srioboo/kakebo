/**
 * Reactive stores for Kakebo frontend
 * Manages filters, pagination, and notifications
 */

import { writable } from 'svelte/store';

// ============================================================================
// Filter Store
// ============================================================================

export interface FilterState {
	searchQuery: string;
	month: string; // YYYY-MM format
	category?: string;
	minAmount?: number;
	maxAmount?: number;
}

const initialFilterState: FilterState = {
	searchQuery: '',
	month: new Date().toISOString().slice(0, 7), // Current month
};

export const filterStore = writable<FilterState>(initialFilterState);

/**
 * Reset filters to initial state
 */
export function resetFilters() {
	filterStore.set(initialFilterState);
}

/**
 * Update specific filter fields
 */
export function updateFilter(updates: Partial<FilterState>) {
	filterStore.update((state) => ({
		...state,
		...updates,
	}));
}

// ============================================================================
// Notification Store
// ============================================================================

export type NotificationType = 'success' | 'error' | 'warning' | 'info';

export interface Notification {
	id: string;
	type: NotificationType;
	message: string;
	duration?: number; // milliseconds, undefined = persist
}

export const notificationStore = writable<Notification[]>([]);

let notificationId = 0;

/**
 * Add a notification toast
 */
export function addNotification(
	message: string,
	type: NotificationType = 'info',
	duration: number = 5000,
): string {
	const id = `notification-${++notificationId}`;
	const notification: Notification = {
		id,
		type,
		message,
		duration,
	};

	notificationStore.update((notifications) => [...notifications, notification]);

	// Auto-remove after duration
	if (duration > 0) {
		setTimeout(() => {
			removeNotification(id);
		}, duration);
	}

	return id;
}

/**
 * Remove a notification by ID
 */
export function removeNotification(id: string) {
	notificationStore.update((notifications) =>
		notifications.filter((n) => n.id !== id),
	);
}

/**
 * Clear all notifications
 */
export function clearNotifications() {
	notificationStore.set([]);
}

/**
 * Convenience functions for common notification types
 */
export const notify = {
	success: (message: string, duration?: number) =>
		addNotification(message, 'success', duration),
	error: (message: string, duration?: number) =>
		addNotification(message, 'error', duration ?? 7000), // errors persist longer
	warning: (message: string, duration?: number) =>
		addNotification(message, 'warning', duration),
	info: (message: string, duration?: number) =>
		addNotification(message, 'info', duration),
};

// ============================================================================
// Pagination Store
// ============================================================================

export interface PaginationState {
	currentPage: number;
	pageSize: number;
	totalItems: number;
}

const initialPaginationState: PaginationState = {
	currentPage: 1,
	pageSize: 10,
	totalItems: 0,
};

export const paginationStore = writable<PaginationState>(initialPaginationState);

/**
 * Update pagination state
 */
export function updatePagination(updates: Partial<PaginationState>) {
	paginationStore.update((state) => ({
		...state,
		...updates,
	}));
}

/**
 * Go to next page
 */
export function nextPage() {
	paginationStore.update((state) => {
		const totalPages = Math.ceil(state.totalItems / state.pageSize);
		return {
			...state,
			currentPage: Math.min(state.currentPage + 1, totalPages),
		};
	});
}

/**
 * Go to previous page
 */
export function previousPage() {
	paginationStore.update((state) => ({
		...state,
		currentPage: Math.max(state.currentPage - 1, 1),
	}));
}

/**
 * Reset pagination to first page
 */
export function resetPagination() {
	paginationStore.set(initialPaginationState);
}
