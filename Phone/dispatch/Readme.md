## Dispatch App for sending Dispatches
![phone_dispatch_app](https://user-images.githubusercontent.com/49867381/198904098-3711e276-4a47-4e90-b6ed-94b349cabb73.png)

Go to `phone/apps` and place the folder `sdispatch` located in the `lua` folder

Go to `phone/config` and place the file `config.senddispatch.lua` located in the `lua` folder

Go to `phone/web/public/apps` and place the `sdispatch.svg` located in `imgages` inside

Go to `phone/web/src/apps` and place the folder `SDispatch` located in the `ts` folder

Go to `phone/web/src/manifest.tsx` and add:
```lua
import SDispatch from "./apps/SDispatch";
```
Below the other imports and then:
```lua
["sdispatch"]: <SDispatch />
```
Below the other elements

Go to `phone/web/src/index.css` and at the bottom add:
```lua
#dis::-webkit-scrollbar {
  display: none;
}
```

Go to `phone/config/config.apps.lua` and at the bottom add:
```lua
{
  id = "sdispatch",
  name = "Send Dispatch",
  default = true
}
```

Then go to the `phone/web` folder and open a terminal. 
Type `npm i`
This will install node_modules.
Then type `npm run build`

That's it. You can delete node_modules now and deploy the phone into the server

### App made by Dimitri requested by me. I have permission to share it :)