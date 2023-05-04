using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerHoloController : MonoBehaviour
{
    public float riseHeight;
    public float speed;
    public GameObject holo_controller;

    private float height;

    public Quest quest;

    // Start is called before the first frame update
    void Start()
    {
        height = 0;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("foot"))
        {
            GetComponent<Collider>().enabled = false; //Disable Collider
            GetComponent<ParticleSystem>().Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear); //Disable particle systems
            StartCoroutine(controllerRise()); //Rise the controller

            if (quest != null)
            {
                quest.EndQuest();
            }
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
