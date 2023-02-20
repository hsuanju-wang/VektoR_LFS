using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Task: MonoBehaviour
{
    //private TaskManager taskManager;

    [HideInInspector]public DialogueManager dialogueManager;

    public virtual void StartTask() {
/*        taskManager = GameObject.FindObjectOfType<TaskManager>();
        taskManager.CurrentTask = this.GetComponent<Task>();
        taskManager.IsStarted = true;*/

        dialogueManager = FindObjectOfType<DialogueManager>();
    }

    public virtual void EndTask()
    {
/*        taskManager.CurrentTask = null;
        taskManager.IsStarted = false;*/

        dialogueManager.NextDialoguePiece();
    }


}
