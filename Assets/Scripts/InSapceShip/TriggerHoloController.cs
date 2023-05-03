using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerHoloController : MonoBehaviour
{
    public enum TaskNum { Task1, Task2}
    public TaskNum taskNum;

    public float riseHeight;
    public float speed;
    public GameObject holo_controller;

    public InSpaceshipDM dialogueManager;
    public GameObject task;
    private float height;


    // Start is called before the first frame update
    void Start()
    {
        height = 0;
        dialogueManager = FindObjectOfType<InSpaceshipDM>();
        //StartCoroutine(controllerRise());
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("foot"))
        {
            GetComponent<Collider>().enabled = false;
            GetComponent<ParticleSystem>().Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
            StartCoroutine(controllerRise());

            if (taskNum == TaskNum.Task1)
            {
                dialogueManager.OpenScanPopup();
            }
            else
            {
                task.GetComponent<Task>().EndTask();
            }
            //dialogueManager.NextDialoguePiece();
        }
    }

    private IEnumerator controllerRise()
    {
        while (height <= riseHeight)
        {
            height += speed * Time.deltaTime;
            holo_controller.transform.position += new Vector3(0f, speed * Time.deltaTime, 0f);
            yield return null;
        }
        //Enable boxcollider
        holo_controller.GetComponent<Collider>().enabled = true;
    }
}
