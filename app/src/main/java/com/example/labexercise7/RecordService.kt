package com.example.labexercise7

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.engine.cio.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json


class RecordService {
    private val baseUrl = "http://192.168.1.7/recit_testing_140p"
    private val client = HttpClient(CIO) {
        install(ContentNegotiation) {
            json(Json { ignoreUnknownKeys = true })
        }
    }

    suspend fun getSubjects(): List<Subject> {
        return try {
//            val response: HttpResponse = client.get("$baseUrl/subjects")
//            response.body()
            val response: HttpResponse = client.get("$baseUrl/subjects")
            println("Raw response: ${response.bodyAsText()}")
            response.body<List<Subject>>() // ✅ Proper deserialization

        } catch (e: Exception) {
            e.printStackTrace()
            emptyList()
        }
    }

    suspend fun addSubject(request: AddSubjectRequest): Boolean {
        return try {
            val response: HttpResponse = client.post("$baseUrl/subjects") {
                contentType(ContentType.Application.Json)
                setBody(request)
            }
            response.status == HttpStatusCode.OK
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
