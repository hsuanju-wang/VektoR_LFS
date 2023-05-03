using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Laser : MonoBehaviour
{
    /// <summary>
    /// This class handles the trigger of laser and samples. 
    /// </summary>
    /// 

    public Material hoverMaterial;
    public Material normalMaterial;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("sample"))
        {
            //Debug.Log("sample trigger");
            this.GetComponent<MeshRenderer>().material = hoverMaterial;
            CollectHandler.s.isCollecting = true;
            CollectHandler.s.StartDissolveSample(other.gameObject);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("sample"))
        {
            //Debug.Log("sample trigger exit");
            this.GetComponent<MeshRenderer>().material = normalMaterial;
            CollectHandler.s.isCollecting = false;
        }
    }
}
