# RSA-encryption-in-Verilog
Simple RSA, Result = "A^B mod C", 8 bit RSA but easily extendable. 
- No side channel attack resistance but power efficient
- Do not put small number on "A"&"B" otherwise encription does not work. 
- "C" must be always bigger than "Hreg" otherwise outcome is not correct. So, put a big number on "C".

## Intro
![image](https://user-images.githubusercontent.com/53184086/187134692-070b84e4-bddc-42c6-adce-d75f3bafddb0.png)
![image](https://user-images.githubusercontent.com/53184086/187134756-56e77ffe-e34a-48c4-9aa9-63900c50682c.png)
![image](https://user-images.githubusercontent.com/53184086/187134795-fbd05446-f1d9-4f2a-90e0-740404c26f81.png)
![image](https://user-images.githubusercontent.com/53184086/187134875-7b536e6f-c4c4-487f-b28a-be7f750082b9.png)

## Design and Block diagram
![image](https://user-images.githubusercontent.com/53184086/187070914-c816e196-ee8f-4762-ab9b-9c5127eaa2a4.png)
![image](https://user-images.githubusercontent.com/53184086/187070940-46ad9f74-ef91-4b26-8d59-0f57b17252bb.png)
![image](https://user-images.githubusercontent.com/53184086/187070952-771f428b-db3f-4d73-9ce5-ac5298db519a.png)
![image](https://user-images.githubusercontent.com/53184086/187070973-e89188cf-9434-47d4-8f2f-b2c0e5256d88.png)
![image](https://user-images.githubusercontent.com/53184086/187071014-42eddfa1-d0a7-4612-9bee-63406499c4a4.png)
![image](https://user-images.githubusercontent.com/53184086/187071081-be36b685-772e-405e-9617-1de014e70dce.png)

## State diagram and Coding
![image](https://user-images.githubusercontent.com/53184086/187013238-017023a1-50bd-47af-8812-4ab58d1ff9db.png)
![image](https://user-images.githubusercontent.com/53184086/187013255-0c595829-6fc5-4766-93fc-5cfc47c82c78.png)
![image](https://user-images.githubusercontent.com/53184086/187013274-aa1161ac-64f2-474d-b063-2607d97d984f.png)
![image](https://user-images.githubusercontent.com/53184086/187013284-ebba4831-867d-4903-afaf-94990cd50ddc.png)

