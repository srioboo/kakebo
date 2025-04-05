<script lang="ts">
	let { data } = $props();
 	// const { posts, error } = data;
	const { expenses, incomes, error } = data;
</script>

<div class="container h-full mx-auto flex flex-row justify-center items-center">
	<div class="flex-col">
		<h2>Ordena tus ingresos y gastos mensuales</h2>

		<!-- Tabla de ingresos -->
		<div class="table-container">
			<div class="border-1 border-white p-5 font-extrabold">Ingresos</div>
			<table class="table ">
				<thead>
					<tr>
						<th>Id</th>
						<th>Concepto</th>
						<th>Importe</th>
						<th>Fecha</th>
					</tr>
				</thead>
				<tbody>
					{#if data}
						{#each incomes?.data as income}
							<tr>
								<td>{income?.id}</td>
								<td>{income?.incomeName}</td>
								<td>{income?.amount}</td>
								<td>{income?.incomeDate}</td>
							</tr>
						{/each}
					{:else}
						  <tr>
							<td>No data found!</td>
						  </tr>
					{/if}
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2"> Total: 2300€ </td>
					</tr>
				</tfoot>
			</table>
		</div>

		<!-- Tabla de gastos -->
		<div class="table-container">
			<div class="border-1 border-white p-5 font-extrabold">Gatos fijos (estimados)</div>
			<table class="table ">
				<thead>
					<tr>
						<th>Id</th>
						<th>Fecha</th>
						<th>Concepto</th>
						<th>Importe</th>
					</tr>
				</thead>
				<tbody>

				{#if data}
					{#each expenses?.data as expense}
						<tr>
							<td>{expense?.id}</td>
							<td>{expense?.expenseName}</td>
							<td>{expense?.amount}</td>
							<td>{expense?.expenseDate}</td>
						</tr>
					{/each}
				{:else}
						<tr>
						<td>No data found!</td>
						</tr>
				{/if}
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2"> Total: 400€ </td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>

	<div class="flex-col">
		<div class="space-y-10 text-center flex flex-col items-center">
			<h2 class="h2">Resumen Enero</h2>
			<h3 class="h3">¿Cuanto tines para gastar en el mes?</h3>
			<p>Ingreso - gatos = 566€</p>

			<h3 class="h3">¿Cual es tu objetivo mensual?</h3>
			<p>Mi objetivo es .....</p>
			<ul>
				<li>objetivo 1</li>
				<li>objetivo 2</li>
			</ul>
			<h3>Prometo</h3>
			<ul>
				<li>promesa 1</li>
				<li>promesa 2</li>
			</ul>
		</div>
	</div>
</div>

<style lang="postcss">
	@reference "tailwindcss";
	@reference "../app.css";

	/*@keyframes glow {
		0% {
			@apply bg-primary-400/50;
		}
		33% {
			@apply bg-secondary-400/50;
		}
		66% {
			@apply bg-tertiary-400/50;
		}
		100% {
			@apply bg-primary-400/50;
		}
	}

	@keyframes pulse {
		50% {
			transform: scale(1.5);
		}
	}*/
</style>
