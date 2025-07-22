package com.example.labexercise7

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {
    private val recordService = RecordService()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                Surface(modifier = Modifier.fillMaxSize()) {
                    SubjectApp(recordService)
                }
            }
        }
    }
}

@Composable
fun SubjectApp(recordService: RecordService) {
    var id by remember { mutableStateOf("") }
    var name by remember { mutableStateOf("") }
    var subjects by remember { mutableStateOf(emptyList<Subject>()) }
    val scope = rememberCoroutineScope()

    Column(modifier = Modifier.padding(16.dp)) {
        OutlinedTextField(
            value = id,
            onValueChange = { id = it },
            label = { Text("Subject ID") },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = name,
            onValueChange = { name = it },
            label = { Text("Subject Name") },
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 8.dp)
        )

        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(onClick = {
                scope.launch {
                    val success = recordService.addSubject(AddSubjectRequest(id.toInt(), name))
                    if (success) {
                        id = ""
                        name = ""
                        subjects = recordService.getSubjects()
                    }
                }
            }) {
                Text("Add")
            }

            Button(onClick = {
                scope.launch {
                    subjects = recordService.getSubjects()
                }
            }) {
                Text("Fetch All")
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        LazyColumn {
            items(subjects) { subject ->
                Text("• ${subject.id} - ${subject.name}")
            }
        }
    }
}
