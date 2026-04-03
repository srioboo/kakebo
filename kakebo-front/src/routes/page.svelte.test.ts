import { describe, test, expect } from 'vitest';
import '@testing-library/jest-dom/vitest';
import { render, screen } from '@testing-library/svelte';
import Page from './+page.svelte';

describe('/+page.svelte', () => {
	test('should render resumen e items de ingresos y gastos', () => {
		render(Page, {
			data: {
				error: null,
				incomes: {
					data: [{ id: 1, incomeName: 'Nomina', amount: 1200, incomeDate: '2026-04-01' }]
				},
				expenses: {
					data: [{ id: 10, expenseName: 'Alquiler', amount: 600, expenseDate: '2026-04-02' }]
				}
			}
		});

		expect(screen.getByRole('heading', { level: 2, name: 'Resumen Enero' })).toBeInTheDocument();
		expect(screen.getByText('Nomina')).toBeInTheDocument();
		expect(screen.getByText('Alquiler')).toBeInTheDocument();
	});
});
