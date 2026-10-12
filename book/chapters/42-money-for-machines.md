# Money for Machines {#money}

Agents are about to become the largest group of customers on the internet, and almost nothing on the internet knows how to take their money.

Look at how a human pays for an API today: sign up with an email, confirm the email, enter a card, pass a fraud check, copy a key from a dashboard into a config file. Every step assumes a person with a browser, a phone and a billing address. An agent has none of those. It has a task, a budget, and an HTTP client.

If agents are going to buy compute, data, API calls and each other's work, payment has to look like the rest of what agents do: a request, a response, a signature. That is the premise of this chapter, and it is why we only take crypto.

## Why crypto, plainly

Skip the ideology. For machines, crypto has three properties card rails do not:

- **No human identity required to hold or send.** An agent can own a wallet. It cannot own a credit card.
- **Programmable and small.** Paying a fraction of a cent for one API call is normal on the right chain and absurd on a card network.
- **Settles without a chargeback window.** When an agent buys a daily pass, the seller does not wait months to learn whether the sale counted.

Our house rule is simple: payments go through CoinPay and x402, and nothing else.

::: rule
**House rule**

Payments are CoinPay and x402 only. Do not add a card checkout to any product. If a feature needs payment, it needs a CoinPay integration.
:::

## CoinPay

::: tool
**Tool: CoinPay**

CoinPay is multi-chain crypto payments with forwarding to the merchant's wallet. It handles BTC, BCH, ETH, POL and SOL plus USDC, at a 0.5% fee. It supports Lightning via BOLT12, escrow for jobs that pay on delivery, a non-custodial web wallet, x402 settlement, and "Sign in with CoinPay", an OAuth and DID login that serves as the single sign-on hub across our products.

```bash
npm install @profullstack/coinpay
```

Site: [coinpayportal.com](https://coinpayportal.com)
:::

Precision matters here. The CoinPay web wallet is non-custodial: your keys, your coins. The payment processing side forwards funds to the merchant's wallet. Know which part you are using and say so accurately to your own customers.

### What agents do with it

Three patterns cover most of what we build:

**Agents that pay.** An agent gets a wallet and a budget. When it needs something (a crawl pass, a GPU hour, a premium API), it pays from the wallet through the SDK. The budget is the leash.

**Agents that get paid.** A bounty board or gig marketplace funds an escrow. The agent (or the human behind it) delivers. The escrow releases. No invoice, no net 30, no "the finance team will process it Thursday".

**Products that charge.** Every product in our fleet takes money the same way, through CoinPay, so a customer with a wallet can pay any of them without signing up for a new billing relationship. When one of our products pays another (and many do), it pays through the same rail.

::: tip
**Tip**

Give each agent its own wallet with a small balance rather than a key to the company treasury. A wallet with fifty dollars in it is a hard spend limit that no bug can exceed.
:::

## x402: the status code the web forgot

HTTP has had a status code for this since the 1990s: `402 Payment Required`. For decades it was "reserved for future use". The future showed up, and it is full of bots.

The x402 idea is that a server answers a request it wants paid for with a 402 and a machine-readable description of the price. The client pays, retries with proof of payment, and gets the content. No signup, no API key dashboard, no sales call. Just HTTP.

::: tool
**Tool: x402-gateway**

`@profullstack/x402-gateway` is one middleware with no database. People and search or retrieval bots read free. Training crawlers (GPTBot, CCBot and their friends) get a 402 with a daily pass, settled through CoinPay. Pair it with `@profullstack/x402-client` on the paying side and `@profullstack/throttle` for rate policy.

```bash
npm install @profullstack/x402-gateway
```
:::

### Why split humans from crawlers

Every content site is now subsidizing model training. A training crawler takes the whole site, every day, and sends back zero readers. A search bot that cites you sends readers. A person reading is the whole point.

So the gateway draws the line where the value is: readers and the bots that bring readers are free, bulk training pays a daily toll. It is not a wall. It is a price tag on the one use that was always extracting value without returning any. Every site in our fleet runs it, and every pass settles through CoinPay.

### The agent side

Flip it around. Your agents are crawlers too. When one of them hits a 402, the right behaviour is not to fail the task, and not to spoof a browser user agent to sneak past. It is to read the price, check the budget, pay, and continue. That is what `x402-client` is for.

```js
// an agent fetch that pays a 402 when it meets one
import { createClient } from '@profullstack/x402-client';

const client = createClient({
  key: process.env.X402_PRIVATE_KEY, // from the vault, never a .env file
  maxUsd: 1,                         // refuse any single payment above $1
});

const res = await client.fetch('https://rssamplifier.com/some/page');
// 402, paid, then the page. The pass is filed by origin,
// so the next request to that site pays nothing.
```

The client signs a USDC authorization locally, so the agent never sends a transaction or holds ETH. It also ships adapters for axios, got, Crawlee, Puppeteer and Playwright, and a CLI (`x402 pass URL`) for curl.

## Budgets are the real control

Here is the part people skip. Once agents can pay, the most important security setting is not a permission, it is a number. How much can this agent spend per request, per day, per task?

- Set a per-request ceiling, so one bad price cannot drain anything.
- Set a per-wallet balance, so one runaway loop has a floor.
- Log every payment next to the task that caused it, so you can answer "why did we spend that?"

A human with a company card has a manager, a policy and a monthly statement. An agent with a wallet has whatever limits you wrote down before it started. Write them down.

::: rule
**House rule**

Every agent wallet has a balance you would be fine losing. Top it up on purpose. Never point an agent at the main treasury.
:::

## Where this goes

Today most agent spending is a human's API bill, paid monthly, by card, to a model provider. That will not last. As agents start buying from each other (data, compute, verified work), the payment has to happen inside the request, at machine speed, in amounts no card network will touch. The infrastructure is ready: a 402 status code, a wallet, a settlement rail. The products that accept it first will be the ones agents can actually buy from.
