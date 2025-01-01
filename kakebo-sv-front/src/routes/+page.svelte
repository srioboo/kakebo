<script lang="ts">
	export let data;
 	// const { posts, error } = data;
	const { expenses, error } = data;
</script>

<div class="container h-full mx-auto flex flex-row justify-center items-center">
	<div class="flex-col">
		<h2>Ordena tus ingresos y gastos mensuales</h2>

		<!-- Tabla de ingresos -->
		<div class="table-container">
			<div class="border-1 border-white p-5 font-extrabold">Ingresos</div>
			<table class="table table-hover">
				<thead>
					<tr>
						<th>Fecha</th>
						<th>Concepto</th>
						<th>Importe</th>
					</tr>
				</thead>
				<tbody>

					{#if data}
						<tr>
							<td> Test Api '{expenses?.data.id}'</td>
							<td> Test Api '{expenses?.data.amount}'</td>
							<td> Test Api '{expenses?.data.expenseName}'</td>
						</tr>
					{:else}
						 <!-- else content here -->
						  <tr>
							<td>No data found!</td>
						  </tr>
						 <!-- else content here -->
					{/if}

					<tr>
						<td>12/03/2023</td>
						<td>Sueldo</td>
						<td>2.400 €</td>
					</tr>
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
			<table class="table table-hover">
				<thead>
					<tr>
						<th>Fecha</th>
						<th>Concepto</th>
						<th>Importe</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>12/03/2023</td>
						<td>Hipoteca</td>
						<td>400 €</td>
					</tr>
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
	/* figure {
		@apply flex relative flex-col;
	} */

	@keyframes glow {
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
	}
</style>
