
import { readFile } from 'fs/promises'

const jsonString = (await readFile(process.argv[2])).toString()

const json = JSON.parse(jsonString)

for (let key in json) {
  console.log(`${key.toUpperCase()}=${json[key]}`)
}