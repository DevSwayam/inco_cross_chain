import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import './index.css'
//import eruda from 'eruda'

import { type Chain } from '@wagmi/chains';

//New chain

const redStone: Chain = {
 id: 17001,
 network: "Red Stone Network",
 name: "RED",
 nativeCurrency: {
     name: "Red Stone",
     symbol: "RED",
     decimals: 18,
  },
 rpcUrls: {
     default: {
         http: ["https://rpc.holesky.redstone.xyz/"],
      },
     public: {
         http: ["https://rpc.holesky.redstone.xyz/"],
      },
  },
 blockExplorers: {
     default: {
         name: "Explorer",
         url: "https://explorer.testnet.inco.org/",
      },
  },
};

import WebApp from '@twa-dev/sdk';

import {PrivyProvider} from '@privy-io/react-auth';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const handleLogin = (user: any) => {
  console.log(`User ${user.id} logged in!`)
}

WebApp.ready();
//eruda.init();

let loginMethods = ['sms', 'email', 'discord'];

if (WebApp.platform === "weba" || WebApp.platform === "webk") {
  loginMethods = ['google', ...loginMethods];
}
if (WebApp.platform !== "android" && WebApp.platform !== "ios") {
  loginMethods = ['wallet', ...loginMethods];
}

ReactDOM.createRoot(document.getElementById('root')!).render(
  <PrivyProvider
        appId="clnkryb030404jr0f78yjv56n"
        onSuccess={handleLogin}
        config={{
          loginMethods: loginMethods as ("sms" | "email" | "discord" | "wallet" | "google" | "twitter" | "github" | "linkedin" | "tiktok" | "apple")[],
          appearance: {
            theme: 'light',
            accentColor: '#676FFF',
            logo: 'https://your-logo-url',
          },
          supportedChains: [redStone],
        }}>
  <React.StrictMode>
    <App />
  </React.StrictMode>
  </PrivyProvider>,
)
