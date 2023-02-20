using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StepTrigger : MonoBehaviour
{
    public Step step;

    void Start()
    {
        step = GameObject.FindObjectOfType<Step>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("foot"))
        {
            step.NextStep();
        }
    }
}
