# fmdb_example
example

####version number
Xcode (v11.3 (11C29))
FMDB (v2.7.5)
FMDB / SQLCipher (FMDB v2.7.5, SQLCipher v3.1.0)
In the project, I used a mixture of native and flutter development. The native project used FMDB / SQLCipher to process the encrypted database, and the flutter code used FMDB to perform another database operation, which caused the database decryption process in the native project to fail. , The reason is the same as the Demo currently provided,
In the case where both FMDB and FMDB / SQLCipher introduce pods, I cannot solve the error problem that appears, I hope you can help me solve this problem
