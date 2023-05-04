using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoloController : MonoBehaviour
{
    public Quest quest;
    public float controllerStayTime;
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("hand"))
        {
            GetComponent<Collider>().enabled = false;
            StartCoroutine(CloseController());
            quest.EndQuest();
        }
    }
    private IEnumerator CloseController()
    {
        yield return new WaitForSeconds(controllerStayTime);
        GetComponent<MeshRenderer>().enabled = false;
    }
}
