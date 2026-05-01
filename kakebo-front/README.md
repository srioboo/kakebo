# Kakebo Front

Frontend de Kakebo construido con SvelteKit 2, Svelte 5, TailwindCSS 4 y Paraglide (i18n).

## Flujo principal (Bun)

### Instalar dependencias

```bash
bun install
```

### Desarrollo

```bash
bun run dev
```

### Build y preview

```bash
bun run build
bun run preview
```

### Calidad y tests

```bash
bun run check
bun run lint
bun run format
bun run test:unit
bun run test:e2e
```

## Variable de entorno

Para consumir datos reales, define `VITE_API_BASE_URL` (usada por `src/lib/api.ts` para `/incomes` y `/expenses`).

## Alternativa con npm

Si prefieres npm, los scripts equivalentes existen en `package.json`:

```bash
npm install
npm run dev
npm run build
npm run preview
```
