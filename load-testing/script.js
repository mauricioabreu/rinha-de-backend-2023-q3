import http from 'k6/http';
import { check, sleep } from 'k6';

const firstNames = ["João", "Maria", "Lucas", "Ana", "Gabriel", "Beatriz", "Felipe", "Camila", "Guilherme", "Juliana"];
const lastNames = ["Silva", "Santos", "Oliveira", "Lima", "Pereira", "Costa", "Rodrigues", "Almeida", "Nascimento", "Gomes"];
const stack = ["JavaScript", "Python", "Java", "C#", "Ruby", "Go", "Rust", "PHP", "Swift", "Kotlin"]

function makeName(firstNames, lastNames) {
    let firstName = firstNames[Math.floor(Math.random() * firstNames.length)];
    let lastName = lastNames[Math.floor(Math.random() * lastNames.length)];

    return `${firstName} ${lastName}`;
}

function makeNickname(name) {
    return `${name}_${randomString(5)}`.substring(0, 32);
}

function randomDate(start, end) {
    return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime())).toISOString().slice(0, 10);
}

function randomString(length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    for (let i = 0; i < length; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
}

export const options = {
    stages: [
        { duration: '1m', target: 500 },
        { duration: '1m', target: 800 },
        { duration: '1m', target: 0 },
    ],
};

export default function () {
    let nome = makeName(firstNames, lastNames);
    let apelido = makeNickname(nome);
    let payload = JSON.stringify({
        "apelido": apelido,
        "nome": nome,
        "nascimento": randomDate(new Date(1990, 0, 1), new Date()),
        "stack": stack.slice(0, Math.floor(Math.random() * stack.length))
    })

    let params = {
        headers: {
            'Content-Type': 'application/json',
        },
    };

    let response = http.post('http://host.docker.internal:9999/pessoas', payload, params);
    check(response, {
        'status is 201': (r) => r.status === 201,
    })

    sleep(1);
}
